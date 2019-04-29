defmodule VintageNet.Persistence.FlatFileTest do
  use VintageNetTest.Case
  alias VintageNet.Persistence.FlatFile

  test "saves and loads configurations", context do
    in_tmp(context.test, fn ->
      config = %{
        type: VintageNet.Technology.Ethernet,
        ipv4: %{method: :dhcp},
        hostname: "unit_test"
      }

      FlatFile.save("eth0", config)

      assert {:ok, config} = FlatFile.load("eth0")
    end)
  end

  test "unknown configurations return error", context do
    in_tmp(context.test, fn ->
      assert {:error, _} = FlatFile.load("eth0")
    end)
  end

  test "corrupt configurations return error", context do
    in_tmp(context.test, fn ->
      config = %{
        type: VintageNet.Technology.Ethernet,
        ipv4: %{method: :dhcp},
        hostname: "unit_test"
      }

      FlatFile.save("eth0", config)

      <<_oops, contents::binary>> = File.read!("eth0")
      File.write!("eth0", contents)

      assert {:error, _} = FlatFile.load("eth0")
    end)
  end
end
