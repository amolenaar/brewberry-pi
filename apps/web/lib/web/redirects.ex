defmodule Web.Redirects do
  @moduledoc false
  use Plug.Redirect

  redirect "/", "/index.html"
end
