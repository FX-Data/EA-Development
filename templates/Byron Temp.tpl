<chart>
id=130739886275718661
symbol=EURAUD.bo
period=5
leftpos=4930
digits=5
scale=16
graph=1
fore=0
grid=1
volume=0
scroll=1
shift=0
ohlc=1
one_click=0
askline=0
days=0
descriptions=0
shift_size=20
fixed_pos=0
window_left=52
window_top=52
window_right=890
window_bottom=425
window_type=3
background_color=0
foreground_color=16777215
barup_color=65280
bardown_color=255
bullcandle_color=65407
bearcandle_color=255
chartline_color=65280
volumes_color=3329330
grid_color=-1
askline_color=255
stops_color=255

<window>
height=100
fixed_height=0
<indicator>
name=main
</indicator>
<indicator>
name=Moving Average
period=60
shift=0
method=0
apply=0
color=255
style=0
weight=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=EMA_ARROW
flags=275
window_num=0
<inputs>
MAPeriod=60
MAMethod=0
MAPrice=0
SoundAlert=true
</inputs>
</expert>
shift_0=0
draw_0=3
color_0=65535
style_0=0
weight_0=2
arrow_0=233
shift_1=0
draw_1=3
color_1=65535
style_1=0
weight_1=2
arrow_1=234
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=BinaryComodo
flags=275
window_num=0
<inputs>
FasterEMA=5
SlowerEMA=200
RSIPeriod2=12
Alerts=true
</inputs>
</expert>
shift_0=0
draw_0=3
color_0=32768
style_0=0
weight_0=4
arrow_0=241
shift_1=0
draw_1=3
color_1=255
style_1=0
weight_1=4
arrow_1=242
period_flags=0
show_data=1
</indicator>
</window>

<expert>
name=Singu Simple trend EA V2
flags=279
window_num=0
<inputs>
note1=% of your Account Ballance
Risk=5.0
note2=Expiry Time
ExpireSeconds=300
note3=SVE_RSI_I_Fish Settings
RsiPeriod=4
EmaPeriod=4
InverseFisherIsBelow=30
InverseFisherIsAbove=70
note4=BinaryComodo Settings
FasterEMA=5
SlowerEMA=200
RsiPeriod2=12
note5=EMA Arrow Settings
EMAPeriod3=60
EMAMethod3=0
EMAPrice3=0
note6=How long must the EA run for? (Broker Time)
HourBegin=0
HourEnd=24
</inputs>
</expert>
</chart>

