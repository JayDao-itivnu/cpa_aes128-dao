function state = ShiftRows(state)
state(2,:)=circshift(state(2,:),-1);
state(3,:)=circshift(state(3,:),-2);
state(4,:)=circshift(state(4,:),-3);
end