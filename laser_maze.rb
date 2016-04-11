# Enter your code here. Read input from STDIN. Print output to STDOUT
class Laser

    @map = []

    # Notes:
    # => X designates rows and travels N, S
    # => Y designates columns and travels W, E
    def initialize(layout)
        @map = layout.split("\n")

        # Wall boundaries
        @north_boundary = 0
        @east_boundary = @map[0].length - 1
        @south_boundary = @map.length - 1
        @west_boundary = 0

        # Travel counter
        @counter = 0

        # Initial direction of laser
        @direction = 'E'

        # @history is used to track previous laser moves
        # duplicate trajectories indicate an infinite loop 
        @history = {}

        # #find_laser returns the position of the laser as a tuple
        laser_pos = find_laser
        @x_coord = laser_pos[:x_coord]
        @y_coord = laser_pos[:y_coord]

        self.fire
    end

    def fire
        while(!self.at_wall?)
            self.move
            @counter += 1

            # Loop detection
            if (previously_traveled?)
                @counter = -1
                return
            else
                # Log trajectory as traveled
                @history[trajectory] = true
            end     
        end
    end

    # Update the position and direction of the laser
    # Contact with an object will update the direction according to the object, 
    # i.e. v # => direction = 'S'
    def move
        # puts "#{@direction} #{@x_coord} #{@y_coord}"
        begin
            case @direction
                when 'E'
                    @y_coord += 1
                when 'S'
                    @x_coord += 1
                when 'W'
                    @y_coord -= 1
                when 'N'
                    @x_coord -= 1
            end

            # Update direction with respect to object at specified maze position
            @direction = Doodad.redirect(@map[@x_coord][@y_coord], @direction)
        rescue
        end
    end

    # Return number of steps required to reach the wall (if possible)
    def distance_to_wall
        return @counter
    end

    # Checks current position of laser to see if the position is outside of the dimensions of the laser
    def at_wall?
        return  @x_coord < @north_boundary || 
                @x_coord > @south_boundary || 
                @y_coord < @west_boundary || 
                @y_coord > @east_boundary
    end

    # Checks if trajectory has been previously traveled by laser in the @history hash
    # Return of true if path has previously been traveled with same trajectory
    # repeated entry trajectory -> duplicate proceeding trajectories -> loop
    # 
    # Updated the method to do a O(1) search rather than O(n) 
    # Previous method version was iterating through @history in search of repeats
    def previously_traveled?
        @history[trajectory]
    end

    # Locate position of laser
    def find_laser
        laser_coords = {}

        @map.each_with_index do |row, x_index|
            row.chars.each_with_index do |cell, y_index|
                if cell == '@'
                    laser_coords[:x_coord] = x_index
                    laser_coords[:y_coord] = y_index
                    return laser_coords
                end
            end
        end
    end

    def trajectory
        return "#{@direction} #{@x_coord} #{@y_coord}"
    end

end

module Doodad
    # Doodads change laser direction
    def self.redirect(symbol, direction)
        # puts "I received symbol: #{symbol}"
        case symbol
            when '>'
                return 'E'
            when 'v'
                return 'S'
            when '<'
                return 'W'
            when '^'
                return 'N'
            # 180 degree mirror case
            when 'O'
                case direction
                    when 'E'
                        return 'W'
                    when 'S'
                        return 'N'
                    when 'W'
                        return 'E'
                    when 'N'
                        return 'S'
                end
            # Diagonal mirror case #1
            when '/'
                case direction
                    when 'E'
                        return 'N'
                    when 'S'
                        return 'W'
                    when 'W'
                        return 'S'
                    when 'N'
                        return 'E'
                    end
            # Diagonal mirror case #2
            when '\\'
                case direction
                    when 'E'
                      return 'S'
                    when 'S'
                        return 'E'
                    when 'W'
                        return 'N'
                    when 'N'
                        return 'W'
                    end
            else
                # If no cases match, return the direction that was inputted
                direction
        end
    end
end


layout = ""
while (line = gets) do
    layout += line.strip + "\n"
end

temp = Laser.new(layout)
puts temp.distance_to_wall.to_s