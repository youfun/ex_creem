ExUnit.start()
Mox.defmock(ExCreem.AdapterMock, for: ExCreem.Adapter)
Application.put_env(:ex_creem, :adapter, ExCreem.AdapterMock)
Application.put_env(:ex_creem, :api_key, "test_api_key")
