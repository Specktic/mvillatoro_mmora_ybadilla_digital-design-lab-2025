package OpCodeEnum;

  typedef enum logic [3:0] {
    Add,      // 0000
    Sub,      // 0001
    Mult,     // 0010
    Div,      // 0011
    Mod,      // 0100
    And,      // 0101
    Or,       // 0110
    Xor,      // 0111
    LShift,   // 1000
    RShift    // 1001
  } OpCode;

endpackage