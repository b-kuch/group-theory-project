# based on https://en.wikipedia.org/wiki/Non-commutative_cryptography#Protocols_for_encryption_and_decryption

LoadDynamicModule("/home/bart/gtp/xor.so");
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
    g1 := MappingPermListList([groupSplitIndex..255], [groupSplitIndex+1..256]);
    g2 := PermList(Concatenation([1..groupSplitIndex-1], [groupSplitIndex+1,groupSplitIndex], [groupSplitIndex+2..256]));
    return Group(g1, g2);
end;

GROUP_SIZE := 256;
grp := SymmetricGroup(GROUP_SIZE);

groupSplitIndex := RandomInRange(120, 136);
A := SymmetricGroup(groupSplitIndex);

g_b1 := MappingPermListList([groupSplitIndex..255], [groupSplitIndex+1..256]);
g_b2 := PermList(Concatenation([1..groupSplitIndex-1], [groupSplitIndex+1,groupSplitIndex], [groupSplitIndex+2..256]));
B := Group(g_b1, g_b2);;
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