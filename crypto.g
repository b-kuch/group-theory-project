# based on https://en.wikipedia.org/wiki/Non-commutative_cryptography#Protocols_for_encryption_and_decryption

GROUP_SIZE := 256;
grp := SymmetricGroup(GROUP_SIZE);

A :=  ;
B := ;

x := ;

b := element from A; # secret
z = x^b; # public

r := random element from B;
t := z^r;

m := "message";
C = rec(x^r, hash(t) xor m);

received_t := C[0]^b;
decrypted = rec[1] xor hash(received_t);