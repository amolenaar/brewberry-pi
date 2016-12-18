defmodule Brewberry.Backend do
  @callback temperature?() :: float
  @callback time?() :: DateTime
end
