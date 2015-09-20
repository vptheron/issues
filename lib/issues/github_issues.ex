defmodule Issues.GithubIssues do

  require Logger

  @user_agent [ { "User-agent", "Programming Elixir" }]

  # Use a module attribute to fetch the value at compile time
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    Logger.info "Fetching user #{user}'s project #{project}."
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response(
    {:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Logger.info "Successful response."
    {:ok, :jsx.decode(body)}
  end

  def handle_response(
    {:ok, %HTTPoison.Response{status_code: status, body: body}}) do
    Logger.error "Error #{status} returned"
    {:error, :jsx.decode(body)}
  end

  def handle_response(
    {:error, %HTTPoison.Error{reason: reason}}) do
    Logger.error "Error #{reason}"
    {:error, reason}
  end

end