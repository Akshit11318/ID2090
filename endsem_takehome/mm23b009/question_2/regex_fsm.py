import subprocess
import sys 
import time

def install(package):
    subprocess.check_call(
        [sys.executable, "-m", "pip", "install", package],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )

# List of required packages
required_packages = ["automata-lib"]

# Install required packages
for package in required_packages:
    try:
        __import__(package)
    except ImportError:
        install(package)
        
time.sleep(4)


from automata.fa.dfa import DFA
from automata.fa.nfa import NFA

class FSM:
    def __init__(self, dfa):
        self.dfa = dfa
        self.start_color = '\033[92m'  # Green color
        self.end_color = '\033[0m'  # Reset color

    def match(self, string):
        return self.dfa.accepts_input(string)

    def find_matches(self, string):
        matched_indices = []
        for start_index in range(len(string)):
            for end_index in range(start_index + 1, len(string) + 1):
                substring = string[start_index:end_index]
                if self.match(substring):
                    matched_indices.append((start_index, end_index))
        return matched_indices

    def highlight_match(self, string):
        matched_indices = self.find_matches(string)
        if matched_indices:
            highlighted_string = self.color_text(matched_indices, string)
            return highlighted_string
        return string

    def color_text(self, matched_indices, original_string):
        if not matched_indices:
            return original_string

        start_color = self.start_color
        end_color = self.end_color

        highlighted_string = ''
        last_index = 0

        # Merge overlapping and contiguous matched indices
        merged_indices = []
        current_start, current_end = matched_indices[0]

        for start, end in matched_indices[1:]:
            if start <= current_end:  # Overlapping or contiguous
                current_end = max(current_end, end)
            else:
                merged_indices.append((current_start, current_end))
                current_start, current_end = start, end

        merged_indices.append((current_start, current_end))

        # Highlight merged indices
        for start, end in merged_indices:
            highlighted_string += original_string[last_index:start]
            highlighted_string += start_color + original_string[start:end] + end_color
            last_index = end

        highlighted_string += original_string[last_index:]
        return highlighted_string

def regex_to_fsm(pattern):
    # Convert regex to NFA, then NFA to DFA
    nfa = NFA.from_regex(pattern)
    dfa = DFA.from_nfa(nfa)
    return FSM(dfa)

def main():
    pattern = input("Regular Expression: ")
    string = input("Sample string: ")

    fsm = regex_to_fsm(pattern)
    
    highlighted_string = fsm.highlight_match(string)
    print(f"Output: {highlighted_string}")

if __name__ == "__main__":
    main()

