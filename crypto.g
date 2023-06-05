# based on https://en.wikipedia.org/wiki/Non-commutative_cryptography#Protocols_for_encryption_and_decryption

# LoadDynamicModule("/home/bart/gtp/xor.so");
MyHash := function(data) 
    return data;
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

CheckIfGroupsAreCommutative := function(G1, G2)
    local g1, g2;
    for g1 in GeneratorsOfGroup(G1) do
        for g2 in GeneratorsOfGroup(G2) do
            if g1*g2 <> g2*g1 then
                return false;
            fi;
        od;
    od;
    return true;
end;

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

# wybierz 
# # a od 1 do i, b od i+1 do n
# # permlist, listperm do offsetu
# x := ;

# # Bob
# b := element from A; # secret
# z = x^b; # public

# # Alice
# r := random element from B;
# t := z^r;

# m := "message";
# C = rec(key:=x^r, message:=MyXor(Hash(t), m));

# # Bob
# received_t := C.key^b;
# decrypted = MyXor(rec[1], Hash(received_t));