defmodule AlfrEXco do

end

defmodule AlfrEXco.CMIS do
  use HTTPoison.Base

  def get_browser!(base_url, params \\ []) do
    request = HTTPoison.request! :get,
      base_url <> "/alfresco/cmisbrowser",
      "", # not posting anything
      [], # no special headers
      basic_auth(params)
    request.body
    |> Poison.decode!
  end

  def file_info(repo, params \\ []) do
    request = HTTPoison.request! :get,
      repo["rootFolderUrl"]
       <> "?objectId="
       <> params[:objectId]
       <> "&cmisselector=object"
       <> "&succinct=true",
      "",
      [],
      basic_auth(params)
    request.body
    |> Poison.decode!
  end

  def download(repo, params \\ []) do
    request = HTTPoison.request! :get,
      repo["rootFolderUrl"]
       <> "?objectId="
       <> params[:objectId],
      "",
      [],
      basic_auth(params)
    request.body
  end

  def query(repo, params \\ []) do
    request = HTTPoison.request! :get,
      repo["rootFolderUrl"] 
        <> "/" <> params[:path]
        <> "?" <> params[:selector]
        <> "&" <> params[:opts],
      "",
      [],
      basic_auth(params) 
    request.body
    |> Poison.decode! 
  end

  def build_query_string(proplist) do
    "/" <> proplist[:path]
  end

  def get_repo!(browser) do
    browser[get_repo_ids(browser)]
  end

  def get_repo_ids(browser) do
    case Map.keys(browser) do
      [] -> []
      [id|[]] -> id
      ids -> ids
    end
  end

  defp basic_auth([]), do: []

  defp basic_auth(cred) do
    [hackney: [basic_auth: {cred[:user], cred[:pass]}]]
  end
end
