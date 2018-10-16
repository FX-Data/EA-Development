<chart>
id=130682631664345605
comment=0 minutes 58 seconds left to bar end
symbol=EURUSD
period=1
leftpos=39014
digits=5
scale=32
graph=1
fore=0
grid=1
volume=0
scroll=1
shift=1
ohlc=1
one_click=0
askline=0
days=0
descriptions=0
shift_size=20
fixed_pos=0
window_left=25
window_top=25
window_right=1050
window_bottom=372
window_type=3
background_color=0
foreground_color=16777215
barup_color=65280
bardown_color=65280
bullcandle_color=0
bearcandle_color=16777215
chartline_color=65280
volumes_color=3329330
grid_color=10061943
askline_color=255
stops_color=255

<window>
height=100
fixed_height=0
<indicator>
name=main
<object>
type=23
object_name=CandleClosingTimeRemaining-CCTR
period_flags=0
create_time=1423789786
description=00:00:58
color=12632256
font=verdana
fontsize=9
angle=0
anchor_pos=6
background=0
filling=0
selectable=1
hidden=0
zorder=0
corner=1
x_distance=5
y_distance=3
</object>
<object>
type=21
object_name=time
period_flags=0
create_time=1423789858
description=               < 0:58
color=65535
font=Verdana
fontsize=8
angle=0
anchor_pos=7
background=0
filling=0
selectable=1
hidden=0
zorder=0
time_0=1423797060
value_0=1.139390
</object>
</indicator>
<indicator>
name=Bollinger Bands
period=20
shift=0
deviations=3.000000
apply=0
color=65535
style=3
weight=1
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=BolliToucher
flags=339
window_num=0
<inputs>
BobaPeriod=20
BobaDeviations=3
Use_Sound=true
</inputs>
</expert>
shift_0=0
draw_0=0
color_0=13458026
style_0=0
weight_0=0
shift_1=0
draw_1=0
color_1=13458026
style_1=0
weight_1=0
shift_2=0
draw_2=3
color_2=13353215
style_2=0
weight_2=0
arrow_2=167
shift_3=0
draw_3=3
color_3=15128749
style_3=0
weight_3=0
arrow_3=167
shift_4=0
draw_4=3
color_4=13353215
style_4=0
weight_4=0
arrow_4=238
shift_5=0
draw_5=3
color_5=15128749
style_5=0
weight_5=0
arrow_5=236
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=b-clock_modified
flags=275
window_num=0
<inputs>
BClockClr=65535
ShowComment=true
</inputs>
</expert>
shift_0=0
draw_0=0
color_0=0
style_0=0
weight_0=0
period_flags=0
show_data=1
</indicator>
<indicator>
name=Custom Indicator
<expert>
name=CandleTime
flags=275
window_num=0
<inputs>
location=1
displayServerTime=0
fontSize=9
colour=12632256
</inputs>
</expert>
shift_0=0
draw_0=0
color_0=0
style_0=0
weight_0=0
period_flags=0
show_data=1
</indicator>
</window>

<window>
height=50
fixed_height=0
<indicator>
name=Custom Indicator
<expert>
name=boItalianJob Matrix_v1
flags=851
window_num=1
<inputs>
____BollingerBand=-----------------------------------------
Bands_Period=20
Bands_Deviation=3.0
Bands_Price=0
____RelativeStrengthIndex_RSI=-----------------------------------------
RSI_UpperLevel=70
RSI_LowerLevel=30
RSI_Price=0
RSI_Period=14
Bands_RSIPeriod=20
Bands_RSIDeviation=2.0
____Stochastic=-----------------------------------------
Stoch_UpperLevel=90
Stoch_LowerLevel=10
Stoch_PeriodK=14
Stoch_PeriodD=3
Stoch_Slowing=1
Stoch_PriceField=0
Stoch_MAmethod=0
____ADX_Filter=-----------------------------------------
Enable_ADX_Filter=false
ADX_Level=30
ADX_Period=14
ADX_Price=0
</inputs>
</expert>
shift_0=0
draw_0=3
color_0=2263842
style_0=0
weight_0=2
arrow_0=221
shift_1=0
draw_1=3
color_1=255
style_1=0
weight_1=2
arrow_1=222
shift_2=0
draw_2=3
color_2=12632256
style_2=0
weight_2=1
arrow_2=159
shift_3=0
draw_3=3
color_3=2263842
style_3=0
weight_3=0
arrow_3=110
shift_4=0
draw_4=3
color_4=255
style_4=0
weight_4=0
arrow_4=110
shift_5=0
draw_5=3
color_5=12632256
style_5=0
weight_5=1
arrow_5=159
shift_6=0
draw_6=3
color_6=2263842
style_6=0
weight_6=1
arrow_6=217
shift_7=0
draw_7=3
color_7=255
style_7=0
weight_7=1
arrow_7=218
shift_8=0
draw_8=3
color_8=12632256
style_8=0
weight_8=1
arrow_8=159
shift_9=0
draw_9=3
color_9=2263842
style_9=0
weight_9=1
arrow_9=217
shift_10=0
draw_10=3
color_10=255
style_10=0
weight_10=1
arrow_10=218
shift_11=0
draw_11=3
color_11=12632256
style_11=0
weight_11=1
arrow_11=159
shift_12=0
draw_12=3
color_12=16748574
style_12=0
weight_12=2
arrow_12=159
shift_13=0
draw_13=3
color_13=12632256
style_13=0
weight_13=1
arrow_13=159
min=0.000000
max=6.000000
period_flags=0
show_data=1
<object>
type=23
object_name=text_adx
period_flags=0
create_time=1423789858
description=ADX-Filter
color=16748574
font=Arial Bold
fontsize=8
angle=0
anchor_pos=4
background=0
filling=0
selectable=1
hidden=0
zorder=0
corner=3
x_distance=3
y_distance=15
</object>
<object>
type=23
object_name=text_bbRSI
period_flags=0
create_time=1423789858
description=Band/RSI
color=16748574
font=Arial Bold
fontsize=8
angle=0
anchor_pos=4
background=0
filling=0
selectable=1
hidden=0
zorder=0
corner=3
x_distance=3
y_distance=30
</object>
<object>
type=23
object_name=text_stochastic
period_flags=0
create_time=1423789858
description=Stochastic
color=16748574
font=Arial Bold
fontsize=8
angle=0
anchor_pos=4
background=0
filling=0
selectable=1
hidden=0
zorder=0
corner=3
x_distance=3
y_distance=45
</object>
<object>
type=23
object_name=text_bandCross
period_flags=0
create_time=1423789858
description=Band-Cross
color=16748574
font=Arial Bold
fontsize=8
angle=0
anchor_pos=4
background=0
filling=0
selectable=1
hidden=0
zorder=0
corner=3
x_distance=3
y_distance=60
</object>
<object>
type=23
object_name=text_signal
period_flags=0
create_time=1423789858
description=## SIGNAL ##
color=16748574
font=Arial Bold
fontsize=8
angle=0
anchor_pos=4
background=0
filling=0
selectable=1
hidden=0
zorder=0
corner=3
x_distance=3
y_distance=75
</object>
</indicator>
</window>
</chart>

