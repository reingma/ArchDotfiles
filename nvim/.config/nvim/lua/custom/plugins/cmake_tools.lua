return {
  {
    "CivitasV/cmake-tools.nvim",
    opts = {
      cmake_build_directory = "build",
      cmake_generator = "Ninja",
      cmake_generate_options = { "-DC MAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_build_options = { "-j12" },
    },
  },
}
