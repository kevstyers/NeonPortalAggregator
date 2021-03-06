app <- ShinyLoadDriver$new()
app$snapshotInit("myloadtest")

Sys.sleep(2.5)
app$setInputs(UniqueStreams = "D10_STER", timeout_ = 10000)
Sys.sleep(3.7)
app$setInputs(dpidID = "DP1.00005.001", timeout_ = 10000)
Sys.sleep(3.7)
app$setInputs(stat = "dailyMax", timeout_ = 8000)
Sys.sleep(2.0)
app$setInputs(stat = "dailyMin", timeout_ = 5000)
Sys.sleep(2.3)
app$setInputs(dpidID = "DP1.00001.001", timeout_ = 13000)
Sys.sleep(6.6)
app$setInputs(dateRange = c("2013-12-29", "2020-06-02"), timeout_ = 12000)

app$snapshot()
app$stop()
app$getEventLog()
