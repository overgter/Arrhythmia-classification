######################################################################
# The state-machine is designed to
#determine the four rhythm-level arrhythmia: bigeminy (B),
#trigeminy (TR), couplet (coup), ventricular tachycardia (VT).
#The input beat symbols are normal (N) and ventricular (V)
#beats.
######################################################################
# Enter values below for
# q_0 : the initial state (an int)
# q_a : the accept state (an int)
# q_r : the reject state (an int)
# delta : the transition function expressed as a dictionary
#         with keys (state, symbol) and values (state, symbol, 'L' or 'R')
# Use the 'b' character for the blank symbol.
#
# For example, you might express the TM that appends a 1 as follows:
#
# q_0 = 0
# q_a = 1
# q_r = 2
# delta = {}
# delta[(0,'0')] = (0,'0')
# delta[(0,'1')] = (0,'1')
# delta[(0,'b')] = (1,'1')
######################################################################



#Build Machine State

class StateMachine:
    def _init_(self):
        self.startState = None
        self.endStates = []
        self.transitions = {}
            
    def set_start(self,index):
        self.startState = index;

    def set_endStates(self,endStates):
        self.endStates = endStates;
        
    def set_transitions(self,delta):
        self.transitions = delta;
        
    def run(self,tape):
        state = self.startState
        head = state
        print(state,tape[head])
        while head < len(tape):
            label = tape[head]
            (newState,result)=self.transitions[state,label]
            print(newState,result)
            if newState in self.endStates:
                print ("arrhythmia: ", result)
                break
            else:
                state = newState
                label = tape[head]                
                head = head + 1

        
#Build set of States
q_0 = 1
q_a = [6,8,13,16]
q_r = '?'

tape = ['b','N','N','N','N','V','V','V','V','N']

#transitions
delta = {}
delta[(1,'N')] = (1,'N')
delta[(1,'V')] = (2,'V')
delta[(2,'N')] = (3,'N')
delta[(2,'V')] = (8,'C')
delta[(3,'N')] = (9,'N')
delta[(3,'V')] = (4,'V')
delta[(4,'N')] = (5,'N')
delta[(4,'V')] = (8,'C')
delta[(5,'N')] = (9,'N')
delta[(5,'V')] = (6,'B')
delta[(6,'N')] = (7,'N')
delta[(6,'V')] = (8,'C')
delta[(7,'N')] = (9,'N')
delta[(7,'V')] = (6,'B')
delta[(8,'N')] = (3,'N')
delta[(8,'V')] = (16,'VT')
delta[(9,'N')] = (1,'N')
delta[(9,'V')] = (10,'V')
delta[(10,'N')] = (11,'N')
delta[(10,'V')] = (8,'C')
delta[(11,'N')] = (12,'N')
delta[(11,'V')] = (4,'V')
delta[(12,'N')] = (1,'N')
delta[(12,'V')] = (13,'TR')
delta[(13,'N')] = (14,'N')
delta[(13,'V')] = (8,'C')
delta[(14,'N')] = (15,'N')
delta[(14,'V')] = (4,'V')
delta[(15,'N')] = (1,'N')
delta[(15,'V')] = (13,'TR')

#TEST
if __name__== "__main__":
    m = StateMachine()
    m.set_start(q_0)
    m.set_endStates(q_a)
    m.set_transitions(delta)
    m.run(tape)
