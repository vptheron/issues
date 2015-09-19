defmodule GithubIssuesTest do
  use ExUnit.Case

  import Issues.GithubIssues, only: [issues_url: 2, handle_response: 1]

  test "URL is correctly formed" do
    assert issues_url("Bob", "Saget") ==
           "https://api.github.com/repos/Bob/Saget/issues"
  end

  test "Handle valid responses" do
    response = %HTTPoison.Response{status_code: 200, body: "Hello"}
    assert handle_response({:ok, response}) == {:ok, "Hello"}
  end

  test "Handle invalid responses" do
     response = %HTTPoison.Response{status_code: 404, body: "NotFound"}
     assert handle_response({:ok, response}) == {:error, "NotFound"}
  end

  test "Handle errors" do
    error = %HTTPoison.Error{reason: "Failure"}
    assert handle_response({:error, error}) == {:error, "Failure"}
  end

end