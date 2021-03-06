from behave import then

from behaveasl import assertions
from behaveasl.models.state_machine import StateMachineModel
from behaveasl.models.state_models import (
    ChoiceState,
    FailState,
    MapState,
    ParallelState,
    PassState,
    SucceedState,
    TaskState,
    WaitState,
)


@then("the parser fails")
def then_parser_fails(context):
    assert context.thrown is not None


@then('a "{class_name}" is created')
def then_object_is_created(context, class_name):
    assert isinstance(context.state_machine, StateMachineModel)


@then('the "{step_name}" step is a "{class_name}" object')
def then_step_is_created_with_correct_object_type(context, step_name, class_name):
    # Get the step out of the state machine
    step_to_evaluate = context.state_machine._states[step_name]
    step_class = str(type(step_to_evaluate))
    expected_class = f"<class 'behaveasl.models.state_models.{class_name}'>"
    # There should be a better way to do this w/isinstance and dynamic class loading but I can't think of it right now
    assert step_class == expected_class


@then("the step result data is not")
def then_full_match_not(context):

    try:
        assertions.assert_json_matches(
            context.text, context.execution.last_step_result.result_data
        )
    except AssertionError as e:
        return
    # Fail if the data actually matched
    assert False
