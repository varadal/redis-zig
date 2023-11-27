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
        try conn.stream.writer().print("Beans\n", .{});
        try handle(conn.stream);
        conn.stream.close();
    }
}

fn handle(stream: net.Stream) !void {
    var count: u8 = 0;

    const writer = stream.writer();
    const reader = stream.reader();

    while (true) : (count += 1) {
        try writer.print("({d}) zig-redis> ", .{count});
        var buf: [256]u8 = undefined;
        const hold = try reader.readUntilDelimiter(&buf, '\n');

        if (hold.len > 0) {
            var tokens = std.mem.tokenizeSequence(u8, hold, " ");
            const command = try tokens.next();
            if ((command != null) and (command[0] == 'q') and (tokens.next() != null)) return;
            try writer.print("curr: {s}\n", .{tokens.buffer});
            try writer.print("peek: {s}\n", .{tokens.peek().?});
            // try redis_handle(hold, writer);
        }
        if (count > 10) return;
    }
}

fn redis_handle(command: []u8, writer: net.Stream.Writer) !void {
    const idx = std.mem.indexOf(u8, command, " ");
    if (idx == null) return; // TODO: throw an error

    const cmd = command[0..idx.?];
    _ = cmd;
    // std.debug.print("PING {s}", .{cmd});
    try writer.print("PING {s}\n", .{command[idx.? + 1 ..]});
}

// TODO:
// 1. be able to consume values being sent to the server
//  a. connections should be stored by the server obj
//  b. how to tell when connections die?
//  c. how to do async?
// 2. move the server to its own file
// 3. get started on the redis part
//
// NOTE: Don't overthink parsing. parse like bash does -> on space unless its enclosed in ""s

// NOTE: tcp-server: https://beej.us/guide/bgnet/html/#a-simple-stream-server
// NOTE: youtube video about creating a server in zig: https://www.youtube.com/watch?v=olOJbYP0ORE&list=PLS87DlLl8etzu2yg5c6a8dDB3wntFsRcj
// NOTE: redis plan: https://app.codecrafters.io/courses/redis/overview
