Feature: options
  In order to debug an ongoing problem
  As a user
  I want to conveniently view logs

  Background:
    Given I have a rails app with git
    And it is on heroku
    And it uses the papertrail addon
    And I install heroku-papertrail

  Scenario: limit to query
    Given the following new logs:
    """
    bar
    foo
    baz

    """
    And I successfully run `heroku pt:logs ba` within the project
    Then I should see these logs:
    """
    bar
    baz

    """

  Scenario: continuous tail option
    Given the following new logs:
    """
    foo1

    """
    When I start `heroku pt:logs -t` within the project
    And the following new logs:
    """
    foo2
    foo3

    """
    And I wait for new logs
    When I press Ctrl-C
    Then I should see these logs:
    """
    foo1
    foo2
    foo3

    """

  Scenario: continuous tail option with query
    Given the following new logs:
    """
    bar
    """
    And I start `heroku pt:logs -t ba` within the project
    And the following new logs:
    """
    foo
    baz

    """
    And I wait for new logs
    When I press Ctrl-C
    Then I should see these logs:
    """
    bar
    baz

    """

  Scenario: continuous tail option should flush
    Given the following new logs:
    """
    foo1

    """
    When I start `heroku pt:logs -t` within the project
    Then I should see these logs before Ctrl-C:
    """
    foo1

    """

  Scenario: continuous tail option should loop
    Given the following new logs:
    """
    foo1

    """
    And I start `heroku pt:logs -t` within the project
    And the following new logs:
    """
    foo2

    """
    And I wait for new logs
    Then I should see these logs:
    """
    foo1
    foo2

    """
    And the following new logs:
    """
    foo3

    """
    And I wait for new logs
    Then I should see these logs before Ctrl-C:
    """
    foo1
    foo2
    foo3

    """
