import copy

import jsonpath_ng

from behaveasl.models.abstract_phase import AbstractPhase
from behaveasl.models.step_result import StepResult


class ResultPathPhase(AbstractPhase):
    def __init__(self, result_path: str = "$"):
        self._path = result_path
        self._expr = jsonpath_ng.parse(result_path)

    def execute(self, state_input, phase_input, sr: StepResult):
        # jsonpath-ng doesn't seem to handle the '$' copy the same way AWS does
        if self._path == "$":
            phase_output = phase_input
        else:
            phase_output = copy.deepcopy(state_input)
            self._expr.update_or_create(phase_output, phase_input)
        print(
            f"ResultPathPhase: Replaced '{state_input}' with '{phase_output}', path='{self._path}', input='{phase_input}'"
        )
        return phase_output


class ParametersPhase(AbstractPhase):
    def __init__(self, parameters):
        self._parameters = parameters

    def execute(self, state_input, phase_input, sr: StepResult):
        phase_output = {}
        # TODO: ASL supports JsonPath in nested values
        for k, v in self._parameters.items():
            # If 'v' is a JsonPath, then eval it against the state_input
            if k.endswith(".$"):
                jpexpr = jsonpath_ng.parse(v)
                results = jpexpr.find(phase_input)
                if len(results) == 1:
                    phase_output[k[0:-2]] = results[0].value
            else:
                phase_output[k] = v
        print(
            f"ParametersPhase: Replaced '{phase_input}' with '{phase_output}', params='{self._parameters}'"
        )
        return phase_output


class OutputPathPhase(AbstractPhase):
    def __init__(self, output_path: str = "$"):
        self._path = output_path
        self._expr = jsonpath_ng.parse(output_path)

    def execute(self, state_input, phase_input, sr: StepResult):
        res = self._expr.find(phase_input)
        if len(res) == 1:
            phase_output = res[0].value
            print(
                f"OutputPathPhase: Replaced '{phase_input}' with '{phase_output}', path='{self._path}'"
            )
            return phase_output


class InputPathPhase(AbstractPhase):
    def __init__(self, input_path: str = "$"):
        self._path = input_path
        self._expr = jsonpath_ng.parse(input_path)

    def execute(self, state_input, phase_input, sr: StepResult):
        res = self._expr.find(phase_input)
        if len(res) == 1:
            phase_output = res[0].value
            print(
                f"InputPathPhase: Replaced '{phase_input}' with '{phase_output}', path='{self._path}'"
            )
            return phase_output