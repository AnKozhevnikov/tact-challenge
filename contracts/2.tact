import "@stdlib/deploy";

message(0x44) Refund {
  queryId: Int as uint64;
  sender: Address;
}

contract Task2 with Deployable {
  admin: Address;
  init(admin: Address) {
    self.admin = admin;
  }

  receive(msg: Slice) {
    send(SendParameters{
      to: self.admin,
      value: 0,
      mode: SendRemainingValue,
      body: beginCell()
      .storeRef(beginCell().storeSlice(msg).endCell())
      .storeAddress(sender())
      .endCell()
    });
  }

  receive(msg: Refund) {
    require(self.admin == sender(), "");
    send(SendParameters{
      to: msg.sender,
      value: 0,
      bounce: true,
      mode: SendRemainingValue
    });
  }
}
