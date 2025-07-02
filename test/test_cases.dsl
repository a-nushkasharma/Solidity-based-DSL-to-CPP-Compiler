//1. Simple Arithmetic & Return

contract MathContract {
    function compute() public returns (uint) {
        uint result = 10 * (5 - 2);
        return result;
    }
}
//2. Variable Declaration and Assignment

contract AssignContract {
    function test() public returns (uint) {
        uint x = 5;
        x = x + 3;
        return x;
    }
}
//3. Boolean Logic and If/Else

contract BoolContract {
    function check() public returns (uint) {
        uint a = 10;
        uint b = 20;
        uint max;
        if (a > b) {
            max = a;
        } else {
            max = b;
        }
        return max;
    }
}
//4.Boolean Conditions and Return

contract LogicContract {
    function isTrue() public returns (bool) {
        bool result = (5 > 3) && (2 < 4);
        return result;
    }
}
//5.Negative Number and Unary Operators

contract NegativeTest {
    function test() public returns (int) {
        int x = -5;
        return x;
    }
}