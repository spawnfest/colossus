defmodule SmartHome.StateServer do
  use GenServer

  @laundry_tick_time 500

  #############################################################################
  ### API
  #############################################################################

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def __get_state do
    GenServer.call(__MODULE__, :__get_state)
  end

  def switch_on(switch_name) do
    GenServer.call(__MODULE__, {:switch_on, switch_name})
  end

  def switch_off(switch_name) do
    GenServer.call(__MODULE__, {:switch_off, switch_name})
  end

  def switch_toggle(switch_name) do
    GenServer.call(__MODULE__, {:switch_toggle, switch_name})
  end

  def laundry_start do
    GenServer.call(__MODULE__, :laundry_start)
  end

  def laundry_stop do
    GenServer.call(__MODULE__, :laundry_stop)
  end

  #############################################################################
  ### Callbacks
  #############################################################################

  def init(_args) do
    {:ok, %SmartHome{}}
  end

  def handle_call(:__get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:switch_on, switch_name}, _from, state) do
    case Map.get(state.switches, switch_name) do
      nil -> {:reply, :error, state}
      value -> {:reply, :ok, put_in(state, [:switches, switch_name], true)}
    end
  end

  def handle_call({:switch_off, switch_name}, _from, state) do
    case Map.get(state.switches, switch_name) do
      nil -> {:reply, :error, state}
      value -> {:reply, :ok, put_in(state, [:switches, switch_name], false)}
    end
  end

  def handle_call({:switch_toggle, switch_name}, _from, state) do
    case Map.get(state.switches, switch_name) do
      nil -> {:reply, :error, state}
      value -> {:reply, :ok, put_in(state, [:switches, switch_name], not value)}
    end
  end

  def handle_call(:laundry_start, _from, state) do
    Process.send_after(self(), :laundry_tick, @laundry_tick_time)

    {
      :reply,
      :ok,
      state
      |> put_in([:washing_machine, :status], :in_progress)
      |> put_in([:washing_machine, :progress], 0)
    }
  end

  def handle_call(:laundry_stop, _from, %{washing_machine: %{status: :stop, progress: _}} = state) do
    {:reply, :ok, state}
  end

  def handle_call(:laundry_stop, _from, %{washing_machine: %{status: :idle, progress: _}} = state) do
    {:reply, :ok, state}
  end

  def handle_call(
        :laundry_stop,
        _from,
        %{washing_machine: %{status: :in_progress, progress: _}} = state
      ) do
    {
      :reply,
      :ok,
      state
      |> put_in([:washing_machine, :status], :stop)
    }
  end

  def handle_info(:laundry_tick, %{washing_machine: %{status: :stop, progress: _}} = state) do
    {:noreply, state}
  end

  def handle_info(
        :laundry_tick,
        %{washing_machine: %{status: :in_progress, progress: 99}} = state
      ) do
    {
      :noreply,
      state
      |> put_in([:washing_machine, :progress], 100)
      |> put_in([:washing_machine, :state], :in_idle)
    }
  end

  def handle_info(
        :laundry_tick,
        %{washing_machine: %{status: :in_progress, progress: progress}} = state
      ) do
    Process.send_after(self(), :laundry_tick, @laundry_tick_time)

    {
      :noreply,
      state
      |> put_in([:washing_machine, :progress], progress + 1)
    }
  end
end
