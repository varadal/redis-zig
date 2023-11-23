const std = @import("std");
const net = std.net;
const StreamServer = net.StreamServer;
const Address = net.Address;

pub fn main() !void {
    var server = StreamServer.init(.{});
    defer server.deinit();
    defer server.close();
    const addr = try Address.resolveIp("127.0.0.1", 8888);

    try server.listen(addr);

    while (true) {
        const conn = try server.accept();
        try conn.stream.writer().print("Beans", .{});
        conn.stream.close();
    }

    // std.debug.print("All your {s} are belong to us.\n", .{"bean"});
    // const stdout_file = std.io.getStdOut().writer();
    // var bw = std.io.bufferedWriter(stdout_file);
    // const stdout = bw.writer();
    // try stdout.print("Run `zig build test` to run the tests.\n", .{});
    // try bw.flush(); // don't forget to flush!
}
