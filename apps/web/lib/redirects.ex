defmodule Brewberry.Redirects do
  use Plug.Redirect

  redirect "/", "/index.html"
end
