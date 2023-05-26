# based on https://en.wikipedia.org/wiki/Non-commutative_cryptography#Protocols_for_encryption_and_decryption

LoadDynamicModule("/home/bart/gtp/xor.so");
MyHash := function(data) 
    return data;
end;

GROUP_SIZE := 256;
grp := SymmetricGroup(GROUP_SIZE);

A :=  ;
B := ;

x := ;

# Bob
b := element from A; # secret
z = x^b; # public

# Alice
r := random element from B;
t := z^r;

m := "message";
C = rec(key:=x^r, message:=MyXor(Hash(t), m));

# Bob
received_t := C.key^b;
decrypted = MyXor(rec[1], Hash(received_t));