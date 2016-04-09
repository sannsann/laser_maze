# Enter your code here. Read input from STDIN. Print output to STDOUT
class Laser

    @map = []

    def initialize(layout)
        @map = layout.split("\n")
        @counter = 0

        # Initial direction of laser
        @direction = 'E'

        # #find_laser returns the position of the laser as a tuple
        laser_pos = find_laser.split(",")
        @x_coord, @y_coord = laser_pos[0].to_i, laser_pos[1].to_i

        # @history is used to track previous laser moves --
        # duplicate trajectories indicate infinite loop
        @history = {}

        self.fire
    end

    def fire
        while(!self.at_wall?)
            self.move
            @counter += 1
        end
    end

    # Update the position and direction of the laser
    # Contact with an object will update the direction according to the object, i.e. v => direction = 'S'
    def move
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
            else
            end

            # Update direction with respect to object at specified maze position
            case @map[@x_coord][@y_coord]
                when '>'
                @direction = 'E'
                when 'v'
                @direction = 'S'
                when '<'
                @direction = 'W'
                when '^'
                @direction = 'N'
                # 180 degree mirror case
                when 'O'
                    case @direction
                    when 'E'
                    @direction = 'W'
                    when 'S'
                    @direction = 'N'
                    when 'W'
                    @direction = 'E'
                    when 'N'
                    @direction = 'S'
                    end
                # Diagonal mirror case #1
                when '/'
                    case @direction
                    when 'E'
                    @direction = 'N'
                    when 'S'
                    @direction = 'W'
                    when 'W'
                    @direction = 'S'
                    when 'N'
                    @direction = 'E'
                    end
                # Diagonal mirror case #2
                when '\\'
                    case @direction
                    when 'E'
                    @direction = 'S'
                    when 'S'
                    @direction = 'E'
                    when 'W'
                    @direction = 'N'
                    when 'N'
                    @direction = 'W'
                    end
            else
            end

            # Checks if trajectory has been previously traveled by laser
            # if so, we know a loop has been entered. Exit accordingly
            if @history.has_value? ("#{@direction} #{@x_coord} #{@y_coord}")
                puts "-1"
                exit
            else
                @history[@counter] = "#{@direction} #{@x_coord} #{@y_coord}"
            end
        rescue
            return
        end
    end

    # Return number of steps required to reach the wall (if possible)
    def distance_to_wall
        return @counter
    end

    # Checks current position of laser to see if the position is outside of the dimensions of the laser
    def at_wall?
        return @x_coord < 0 || @x_coord > @map.length - 1 || @y_coord < 0 || @y_coord > @map[0].length - 1
    end

    # Locate position of laser
    def find_laser
        @map.each_with_index do |row, x_index|
            row.chars.each_with_index do |cell, y_index|
                if cell == '@'
                    return "#{x_index}, #{y_index}"
                end
            end
        end
    end

end

layout = ""
while (line = gets) do
    layout += line.strip + "\n"
end

temp = Laser.new(layout)
puts temp.distance_to_wall
