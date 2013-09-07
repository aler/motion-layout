module Motion
  class Layout
    def initialize(&block)
      @verticals   = []
      @horizontals = []
      @center_x    = []
      @center_y    = []
      @metrics     = {}

      yield self
      strain
    end

    def metrics(metrics)
      @metrics = Hash[metrics.keys.map(&:to_s).zip(metrics.values)]
    end

    def subviews(subviews)
      @subviews = Hash[subviews.keys.map(&:to_s).zip(subviews.values)]
    end

    def view(view)
      @view = view
    end

    def horizontal(horizontal)
      @horizontals << horizontal
    end

    def vertical(vertical)
      @verticals << vertical
    end

    def center_x(view)
      @center_x << view
    end

    def center_y(view)
      @center_y << view
    end

    private

    def strain
      @subviews.values.each do |subview|
        subview.translatesAutoresizingMaskIntoConstraints = false
        @view.addSubview(subview) unless subview.superview
      end

      constraints = []
      constraints += @verticals.map do |vertical|
        NSLayoutConstraint.constraintsWithVisualFormat("V:#{vertical}", options:NSLayoutFormatAlignAllCenterX, metrics:@metrics, views:@subviews)
      end
      constraints += @horizontals.map do |horizontal|
        NSLayoutConstraint.constraintsWithVisualFormat("H:#{horizontal}", options:NSLayoutFormatAlignAllCenterY, metrics:@metrics, views:@subviews)
      end
      constraints += @center_x.map do |v|
        NSLayoutConstraint.constraintWithItem(@view, attribute:NSLayoutAttributeCenterX, relatedBy:NSLayoutRelationEqual, toItem:v, attribute:NSLayoutAttributeCenterX, multiplier:1, constant:0)
      end
      constraints += @center_y.map do |v|
        NSLayoutConstraint.constraintWithItem(@view, attribute:NSLayoutAttributeCenterY, relatedBy:NSLayoutRelationEqual, toItem:v, attribute:NSLayoutAttributeCenterY, multiplier:1, constant:0)
      end

      @view.addConstraints(constraints.flatten)
    end
  end
end
