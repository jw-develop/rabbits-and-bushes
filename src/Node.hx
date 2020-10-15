

enum NodeState {
    Open;
    Closed;
    Impassable;
    Undiscovered;
    Tracing;
}

class Node {

    public var x: Int;
    public var y: Int;
    public var state: NodeState; 
    public var parent: Node;
    public var gScore: Int;
    public var hScore: Int;

    public function new(x, y, state) {
        this.x = x;
        this.y = y;
        this.state = state;
        this.parent = null;
        this.gScore = 100000;
        this.hScore = 0;
    }

    public function fScore() {
        return gScore + hScore;
    }
}