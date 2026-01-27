rollout test "Test Timer"
(
  timer clock "testClock" interval:1000 --tick once a second
  label test"1"
  on clock tick do
  (
    valUp = (test.text as integer)+1
    test.text = valUp as string
  )
)
createDialog test
