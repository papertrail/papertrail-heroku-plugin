Feature: heroku integration
  In order to see logs for current heroku app
  As a heroku user
  I want to have a working heroku papertrail plugin

  Scenario: Install and use
    Given I have a rails app with git
    And it is on heroku
    And it uses the papertrail addon
    And I install heroku-papertrail
    And the following new logs:
    """
    start server
    crash
    restart

    """
    When I successfully run `heroku pt:tail` within the project
    Then I should see these logs:
    """
    start server
    crash
    restart

    """

  Scenario: It should show info when not token
    Given I have a rails app with git
    And it is on heroku
    And I install heroku-papertrail
    When I run `heroku pt:tail` within the project
    Then it should fail with:
    """
    First, please enable the Papertrail addon for this application

    """
