module AgentSupport
  def login_with(credentials={email: Automaton.csr_email,
                              password: Automaton.csr_password})
    visit "/servicing/login"

    fill_in "csr_session_email", :with => credentials[:email]
    fill_in "csr_session_password", :with => credentials[:password]
    click_button "Sign in"
  end
end

World(AgentSupport)
