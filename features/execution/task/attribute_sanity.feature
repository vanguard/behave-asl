Feature: Task attributes that are not considered sane will end execution

  Scenario: The Task type cannot set both TimeoutSeconds and TimeoutSecondsPath
    Given an invalid state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Task",
                "Resource": "Lambda",
                "TimeoutSeconds": 20,
                "TimeoutSecondsPath": "$.Time",
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Task",
                "Resource": "Lambda",
                "End": true
            }
        }
    }
    """
    When the parser runs
    Then the parser fails


  Scenario: The Task type cannot set both HeartbeatSeconds and HeartbeatSecondsPath
    Given an invalid state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Task",
                "Resource": "Lambda",
                "HeartbeatSeconds": 20,
                "HeartbeatSecondsPath": "$.Time",
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Task",
                "Resource": "Lambda",
                "End": true
            }
        }
    }
    """
    When the parser runs
    Then the parser fails


  Scenario: The Task type must set a Resource
    Given an invalid state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Task",
                "Next": "EndState"
            },
            "EndState": {
                "Type": "Task",
                "Resource": "Lambda",
                "End": true
            }
        }
    }
    """
    When the parser runs
    Then the parser fails
