# Create and manage game
class Game
  def tick(args)
    sprites = []
    labels = []
    render(args, sprites, labels)
  end

  def render(args, sprites, labels)
    args.outputs.sprites << sprites
    args.outputas.labels << labels
  end
end

