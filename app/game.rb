# Create and manage game
class Game
  def tick(args)
    sprites = []
    labels = []
    render(args, sprites, labels)
  end

  def render(args, sprites, labels)
    args.outputs.sprites << sprites
    args.outputs.labels << labels
    args.outputs.solids << [0, 240, 1440, 10, 100, 200, 100, 255]
  end
end

