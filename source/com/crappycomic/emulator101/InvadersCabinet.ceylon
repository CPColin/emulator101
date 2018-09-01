"Encapsulates the physical state of the various switches and buttons attached to the cabinet.
 Ephemeral and mutable, unlike [[InvadersMachine]] and [[State]]."
class InvadersCabinet() {
    shared variable Boolean coin = true;
    
    shared variable Boolean player1Start = false;
    shared variable Boolean player1Left = false;
    shared variable Boolean player1Right = false;
    shared variable Boolean player1Fire = false;
    
    shared variable Boolean player2Start = false;
    shared variable Boolean player2Left = false;
    shared variable Boolean player2Right = false;
    shared variable Boolean player2Fire = false;
}
