defmodule ColossusTg.Bot do
  use Agala.Bot.Poller, [
    otp_app: :colossus_tg,
    provider: Agala.Provider.Telegram,
    chain: ColossusTg.Chain,
    provider_params: %Agala.Provider.Telegram.Conn.ProviderParams{
      poll_timeout: :infinity,
      token: Application.get_env(:colossus_tg, :telegram)[:token]
    }
  ]
end
