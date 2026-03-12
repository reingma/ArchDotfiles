return {
  -- Examples of Greek letter snippets, autotriggered for efficiency
  s({ trig = "link", name = "Link", dscr = "Web link" }, {
    t({ "`" }),
    i(1, "Title"),
    t(" <"),
    i(2, "link"),
    t(">`_"),
    i(0),
  }),
}
