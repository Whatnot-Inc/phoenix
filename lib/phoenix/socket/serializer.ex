defmodule Phoenix.Socket.Serializer do
  @moduledoc """
  A behaviour that serializes incoming and outgoing socket messages.

  By default Phoenix provides a serializer that encodes to JSON and
  decodes JSON messages.

  Custom serializers may be configured in the socket.
  """

  alias Phoenix.Socket.Message

  @doc """
  Encodes a `Phoenix.Socket.Broadcast` struct to fastlane format.

  A serializer may return a pre-compressed frame as `{:socket_push, opcode, {raw, deflated}}`,
  where `opcode` is a custom atom (not `:text` or `:binary`) that a patched transport
  recognizes. This lets a broadcast be compressed once and fanned out to many sockets,
  instead of once per socket.
  """
  @callback fastlane!(Phoenix.Socket.Broadcast.t()) ::
              {:socket_push, :text, iodata()}
              | {:socket_push, :binary, iodata()}
              | {:socket_push, atom(), {raw :: iodata(), deflated :: iodata()}}

  @doc """
  Encodes `Phoenix.Socket.Message` and `Phoenix.Socket.Reply` structs to push format.
  """
  @callback encode!(Message.t() | Phoenix.Socket.Reply.t()) ::
              {:socket_push, :text, iodata()}
              | {:socket_push, :binary, iodata()}

  @doc """
  Decodes iodata into `Phoenix.Socket.Message` struct.
  """
  @callback decode!(iodata, options :: Keyword.t()) :: Message.t()
end
