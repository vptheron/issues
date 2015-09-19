defmodule GithubIssuesTest do
  use ExUnit.Case

  import Issues.GithubIssues, only: [issues_url: 2, handle_response: 1]

  test "URL is correctly formed" do
    assert issues_url("Bob", "Saget") ==
           "https://api.github.com/repos/Bob/Saget/issues"
  end

  test "Handle valid responses" do
    body = "{\"msg\" : \"hello\"}"
    response = %HTTPoison.Response{status_code: 200, body: body}
    assert handle_response({:ok, response}) == {:ok, %{"msg" => "hello"}}
  end

  test "Handle invalid responses" do
    body = "{\"msg\" : \"NotFound\"}"
    response = %HTTPoison.Response{status_code: 404, body: body}
    assert handle_response({:ok, response}) == {:error, %{"msg" => "NotFound"}}
  end

  test "Handle errors" do
    error = %HTTPoison.Error{reason: "Failure"}
    assert handle_response({:error, error}) == {:error, "Failure"}
  end

end