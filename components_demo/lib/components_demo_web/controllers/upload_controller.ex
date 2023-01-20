defmodule ComponentsDemoWeb.UploadController do
  use ComponentsDemoWeb, :controller

  # simple endpoint to have a test endpoint to upload to
  def create(conn, _params) do
    json(conn, %{meme: "https://www.youtube.com/watch?v=BW1aX0IbZOE&t=6s"})
  end
end
