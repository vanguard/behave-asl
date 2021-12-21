Feature: Result Data can be checked

  Scenario: Json Path matches
    Given a simple state machine
    When the step result is:
    """
    {
        "hello": "world"
    }
    """
    Then the step result data path "$.hello" matches "world"

  Scenario: Json Path type is int
    Given a simple state machine
    When the step result is:
    """
    {
        "key": 2
    }
    """
    Then the step result data path "$.key" matches "2"
    And the step result data path "$.key" is an int

  Scenario: Json Path type is list
    Given a simple state machine
    When the step result is:
    """
    {
        "key": [
            "A",
            "B"
        ]
    }
    """
    Then the step result data path "$.key" contains "A"
    And the step result data path "$.key" contains "B"
    And the step result data path "$.key" has "2" entries
    And the step result data path "$.key" is a list

  Scenario: Json Path type is dict
    Given a simple state machine
    When the step result is:
    """
    {
        "key": {
            "name": "value"
        }
    }
    """
    Then the step result data path "$.key.name" matches "value"
    And the step result data path "$.key" contains "name"
    And the step result data path "$.key" has "1" entry
    And the step result data path "$.key" is a dict
