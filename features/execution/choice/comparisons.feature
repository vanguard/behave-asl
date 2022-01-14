Feature: Choice Rules and comparisons that should match values in the input/are set to True are supported by the Choice state type (Except for And/Not/Or)

  # https://docs.aws.amazon.com/step-functions/latest/dg/amazon-states-language-choice-state.html#amazon-states-language-choice-state-rules
  Scenario Outline: The Choice type supports the BooleanEquals operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "BooleanEquals": <comparator>,
                        "Next": "MatchState"
                    }
                ],
                "Default": "DefaultState"
            },
            "MatchState": {
                "Type": "Pass"
            },
            "DefaultState": {
                "Type": Pass
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": <input_value>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | comparator | input_value | matched_state |
      | true       | true        | MatchState    |
      | false      | false       | MatchState    |
      | false      | true        | DefaultState  |
      | true       | false       | DefaultState  |
      | true       | "true"      | DefaultState  |

  Scenario Outline: The Choice type supports the BooleanEqualsPath operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "BooleanEqualsPath": "$.mybool",
                        "Next": "EndState"
                    }
                ],
                "Default": "DefaultState"
            },
            "EndState": {
                "Type": "Pass"
            },
            "DefaultState": {
                "Type": "Pass"
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": <value_1>,
        "mybool": <value_2>
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

    Examples: Comparators
      | value_1      | value_2 | matched_state |
      | true         | true    | MatchState    |
      | false        | false   | MatchState    |
      | true         | false   | DefaultState  |
      | false        | true    | DefaultState  |
      | "not_a_bool" | false   | DefaultState  |
      | "true"       | true    | DefaultState  |

  Scenario Outline: The Choice type supports the IsBoolean operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "IsBoolean": true,
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": false
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the IsNull operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "IsNull": true,
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": null
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the IsNumeric operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "IsNumeric": true,
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": 9
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the IsPresent operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "IsPresent": true,
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": "true"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the IsString operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "IsString": true,
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": "blue"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the IsTimestamp operator with no timezone
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "IsTimestamp": true,
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": "2001-01-01T12:00:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the IsTimestamp operator with timezone
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "IsTimestamp": true,
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": "2001-01-01T12:00:00+04:00"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the IsTimestamp operator without timezone
  Scenario Outline: The Choice type supports the NumericEquals operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "NumericEquals": 0,
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": 0
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the NumericEqualsPath operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "NumericEqualsPath": "$.myvalue",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": 10,
        "myvalue": 10
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the NumericGreaterThan operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "NumericGreaterThan": 10,
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": 15
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the NumericGreaterThanPath operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "NumericGreaterThanPath": "$.myvalue",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": 15,
        "myvalue": 10
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the NumericLessThan operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "NumericLessThan": 10,
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": 9
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the NumericLessThanPath operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "NumericLessThanPath": "$.myvalue",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": 10,
        "myvalue": 15
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the StringEquals operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "StringEquals": "blue",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": "blue"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: StringEquals supports comparing Timestamp fields as strings
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.actuallyatimestamp",
                        "StringEquals": "2016-08-18T17:33:00Z",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "actuallyatimestamp": "2016-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the StringEqualsPath operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "StringEqualsPath": "$.otherthing",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": "blue",
        "otherthing": "blue"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the StringGreaterThan operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "StringGreaterThan": "at",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": "so"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the StringGreaterThanPath operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "StringGreaterThanPath": "$.otherthing",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": "so",
        "otherthing": "at",
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the StringLessThan operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "StringLessThan": "so",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": "at"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the StringLessThanPath operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "StringLessThanPath": "$.otherthing",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": "at",
        "otherthing": "so"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the StringMatches operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "StringMatches": "blue",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "thing": "blue"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the TimestampEquals operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.timestamp",
                        "TimestampEquals": "2016-08-18T17:33:00Z",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "timestamp": "2016-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the TimestampEqualsPath operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.timestamp",
                        "TimestampEqualsPath": "$.othertimestamp",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "timestamp": "2016-08-18T17:33:00Z",
        "othertimestamp": "2016-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the TimestampGreaterThan operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.timestamp",
                        "TimestampGreaterThan": "2016-08-18T17:33:00Z"
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "timestamp": "2017-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the TimestampGreaterThanPath operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.timestamp",
                        "TimestampGreaterThanPath": "$.othertimestamp",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "timestamp": "2017-08-18T17:33:00Z",
        "othertimestamp": "2016-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the TimestampGreaterThanEquals operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.timestamp",
                        "TimestampGreatherThanEquals": "$.othertimestamp",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "timestamp": "2016-08-18T17:33:00Z",
        "othertimestamp": "2016-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the TimestampGreaterThanEqualsPath operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "TimestampGreaterThanEqualsPath": "$.othertimestamp",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "timestamp": "2017-08-18T17:33:00Z",
        "othertimestamp": "2016-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the TimestampLessThan operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.timestamp",
                        "TimestampLessThan": "2016-08-18T17:33:00Z",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "timestamp": "2015-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the TimestampLessThanPath operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.timestamp",
                        "TimestampLessThanPath": "$.othertimestamp",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "timestamp": "2015-08-18T17:33:00Z",
        "othertimestamp": "2016-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the TimestampLessThanEquals operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.timestamp",
                        "TimestampLessThanEquals": "2016-08-18T17:33:00Z",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "timestamp": "2015-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"

  Scenario Outline: The Choice type supports the TimestampLessThanEqualsPath operator
    Given a state machine defined by:
    """
    {
        "StartAt": "FirstState",
        "States": {
            "FirstState": {
                "Type": "Choice",
                "Choices": [
                    {
                        "Variable": "$.thing",
                        "TimestampLessThanEqualsPath": "$.othertimestamp",
                        "Next": "EndState"
                    }
                ]
            },
            "EndState": {
                "Type": "Pass",
                "Result": "end",
                "End": true
            }
        }
    }
    """
    And the current state data is:
    """
    {
        "timestamp": "2015-08-18T17:33:00Z",
        "othertimestamp": "2016-08-18T17:33:00Z"
    }
    """
    When the state machine executes
    Then the next state is "<matched_state>"
