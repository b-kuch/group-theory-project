LoadDynamicModule("/home/bart/gtp/xor.so");

Hash := function(perm)
    return HexSHA256(String(perm));
end;

ToChars := function(str)
    return List(str, IntChar);
end;

Xor := function(str1, str2)
    return _Xor(ToChars(str1), ToChars(str2));
end;

RandomInRange := function(startInclusive, endInclusive)
    local localRange;
    localRange := endInclusive - startInclusive;
    return startInclusive + Random(0, localRange);
end;

OffsetSymmetricGroup := function(startExclusive, endInclusive)
    local g1, g2;
    g1 := MappingPermListList([startExclusive+1..endInclusive-1], [startExclusive+2..endInclusive]);
    g2 := PermList(Concatenation([1..startExclusive], [startExclusive+2,startExclusive+1], [startExclusive+3..endInclusive]));
    return Group(g1, g2);
end;


# based on https://en.wikipedia.org/wiki/Non-commutative_cryptography#Protocols_for_encryption_and_decryption

# Algorithm

GROUP_SIZE := 256;
grp := SymmetricGroup(GROUP_SIZE);

groupSplitIndex := RandomInRange(120, 136);
A := SymmetricGroup(groupSplitIndex);
B := OffsetSymmetricGroup(groupSplitIndex, GROUP_SIZE);
if CheckIfGroupsAreCommutative(A, B) then
    Print("Subgroups A and B are commutative.");
else
    Print("Subgroups A and B are not commutative, this is an error.");
fi;

x := Random(A)*Random(B);

# Bob
b := Random(A); # secret
z := x^b; # public

# Alice
r := Random(B);
t := z^r;

m := "message";
hashedT := Hash(t);
C = rec(key:=x^r, message:=Xor(Hash(t), m));

# Bob
receivedT := C.key^b;
decrypted = Xor(Xor(Hash(receivedT), C.message), receivedT);
Print(decrypted);

# fin.