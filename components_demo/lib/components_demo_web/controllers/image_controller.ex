defmodule ComponentsDemoWeb.ImageController do
  use ComponentsDemoWeb, :controller

  def create(conn, params) do
    image_params = Map.get(params, "image")

    # Ensure image was provided
    if image_params do
      # Save image to specified directory
      # path = "path/to/uploaded_images"
      file_name = "#{DateTime.utc_now()}-#{image_params.filename}"

      # File.cp(image_params.path, "#{path}/#{file_name}")

      # Respond with image URL
      json(conn, %{url: "http://example.com/#{file_name}"})
    else
      json(conn, %{error: "Image not provided"})
    end
  end
end
