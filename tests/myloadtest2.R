app <- ShinyLoadDriver$new()
app$snapshotInit("myloadtest2")

Sys.sleep(4.6)
app$setInputs(UniqueStreams = "D03_JERC", timeout_ = 21000)
Sys.sleep(1.3)
app$setInputs(dpidID = "DP1.00002.001", timeout_ = 14000)
Sys.sleep(6.1)
app$setInputs(dateRange = c("2014-12-28", "2020-06-02"), timeout_ = 23000)

app$snapshot()
app$stop()
app$getEventLog()
