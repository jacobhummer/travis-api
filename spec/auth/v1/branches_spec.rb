describe 'Auth branches', auth_helpers: true, site: :org, api_version: :v1, set_app: true do
  let(:user)  { FactoryBot.create(:user) }
  let(:repo)  { Repository.by_slug('svenfuchs/minimal').first }
  let(:build) { repo.builds.first }

  describe 'in private mode, with a private repo', mode: :private, repo: :private do
    # doesn't work despite the comment on lib/travis/api/app/endpoint/branches.rb#10
    # GET %{repo.slug}/branches

    # documented https://docs.travis-ci.com/api/#branches
    describe 'GET /repos/%{repo.slug}/branches' do
      it(:with_permission)     { should auth status: 200, empty: false }
      it(:without_permission)  { should auth status: 200, empty: true }
      it(:invalid_token)       { should auth status: 403 }
      it(:unauthenticated)     { should auth status: 200, empty: true } # was 401, i think this is acceptable
    end

    describe 'GET /branches?repository_id=%{repo.id}' do
      it(:with_permission)     { should auth status: 200, empty: false }
      it(:without_permission)  { should auth status: 200, empty: true }
      it(:invalid_token)       { should auth status: 403 }
      it(:unauthenticated)     { should auth status: 200, empty: true } # was 401, i think this is acceptable
    end

    describe 'GET /branches?ids=%{build.id}' do
      it(:with_permission)     { should auth status: 200, empty: false }
      it(:without_permission)  { should auth status: 200, empty: true }
      it(:invalid_token)       { should auth status: 403 }
      it(:unauthenticated)     { should auth status: 200, empty: true } # was 401, i think this is acceptable
    end
  end


  # +-------------------------------------------------------------+
  # |                                                             |
  # |   !!! BELOW IS THE ORIGINAL BEHAVIOUR ... DON'T TOUCH !!!   |
  # |                                                             |
  # +-------------------------------------------------------------+

  describe 'in org mode, with a public repo', mode: :org, repo: :public do
    # doesn't work despite the comment on lib/travis/api/app/endpoint/branches.rb#10
    # GET %{repo.slug}/branches

    # documented https://docs.travis-ci.com/api/#branches
    describe 'GET /repos/%{repo.slug}/branches' do
      it(:with_permission)     { should auth status: 200, empty: false }
      it(:without_permission)  { should auth status: 200, empty: false }
      it(:invalid_token)       { should auth status: 403 }
      it(:unauthenticated)     { should auth status: 200, empty: false }
    end

    describe 'GET /branches?repository_id=%{repo.id}' do
      it(:with_permission)     { should auth status: 200, empty: false }
      it(:without_permission)  { should auth status: 200, empty: false }
      it(:invalid_token)       { should auth status: 403 }
      it(:unauthenticated)     { should auth status: 200, empty: false }
    end

    describe 'GET /branches?ids=%{build.id}' do
      it(:with_permission)     { should auth status: 200, empty: false }
      it(:without_permission)  { should auth status: 200, empty: false }
      it(:invalid_token)       { should auth status: 403 }
      it(:unauthenticated)     { should auth status: 200, empty: false }
    end
  end
end