defmodule Web.Redirects do
  use Plug.Redirect

  @moduledoc false

  redirect "/", "/index.html"
end
