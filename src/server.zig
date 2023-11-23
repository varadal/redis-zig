// const net = @import("std").net;
// const StreamServer = net.StreamServer;
// const Address = net.Address;
//
// pub const RedisServer = struct {
//     server: StreamServer,
//
//     pub fn init(self: *RedisServer) void {
//         self.server = StreamServer.init(.{});
//     };
//
//     pub fn deinit(self: *RedisServer) void {
//         self.server.close();
//         self.* = undefined;
//     };
// };
