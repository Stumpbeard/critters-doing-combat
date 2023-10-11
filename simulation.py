win_size = 648
end_target = win_size * 0.9

enemies_spawned = 1

heat_meter = 0
spawn_meter = 0

heat_rate = 0.08
spawn_rate = 1.0

ticks = 0
fps = 60

while heat_meter < end_target:
    heat_meter += heat_rate
    spawn_meter += spawn_rate
    if heat_meter + spawn_meter >= win_size:
        enemies_spawned += 1
        spawn_meter = 0
    ticks += 1

print("Enemies spawned: ", enemies_spawned)
print("Seconds elapsed: ", ticks / fps)
