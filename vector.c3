module vector;
import raylib5;
import std::math;

fn void rl::Vector2.clamp(&self, rl::Vector2 min, rl::Vector2 max){
    self.x = math::clamp(self.x, min.x, max.x);
    self.y = math::clamp(self.y, min.y, max.y);
}

fn void rl::Vector2.add(&self, rl::Vector2 other){
    self.x += other.x;
    self.y += other.y;
}
