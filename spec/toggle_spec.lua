--[[--
Unit tests for pencil enable/disable toggle functionality.
Tests that isEnabled() reads from G_reader_settings and that
the toggle correctly flips the persisted state.
Run with: busted spec/toggle_spec.lua
--]]--

-- Mock G_reader_settings
local MockSettings = {}
MockSettings._store = {}

function MockSettings:readSetting(key)
    return self._store[key]
end

function MockSettings:saveSetting(key, value)
    self._store[key] = value
end

function MockSettings:reset()
    self._store = {}
end

-- Mock Pencil with real isEnabled/setEnabled/onPencilToggleEnabled logic
local function createMockPencil()
    local mock = {
        _setup_called = false,
        _teardown_called = false,
        _notification = nil,
    }

    function mock:isEnabled()
        return G_reader_settings:readSetting("pencil_annotation_enabled") == true
    end

    function mock:setEnabled(enabled)
        G_reader_settings:saveSetting("pencil_annotation_enabled", enabled)
    end

    function mock:setupPenInput()
        self._setup_called = true
    end

    function mock:teardownPenInput()
        self._teardown_called = true
    end

    function mock:onPencilToggleEnabled()
        local enabled = self:isEnabled()
        self:setEnabled(not enabled)
        if self:isEnabled() then
            self:setupPenInput()
            self._notification = "Pencil enabled"
        else
            self:teardownPenInput()
            self._notification = "Pencil disabled"
        end
        return true
    end

    return mock
end

-- Install mock as global
G_reader_settings = MockSettings

describe("pencil toggle", function()

    before_each(function()
        MockSettings:reset()
    end)

    describe("isEnabled", function()

        it("returns false when setting is nil (first install default)", function()
            local pencil = createMockPencil()
            assert.is_false(pencil:isEnabled())
        end)

        it("returns true when setting is true", function()
            local pencil = createMockPencil()
            G_reader_settings:saveSetting("pencil_annotation_enabled", true)
            assert.is_true(pencil:isEnabled())
        end)

        it("returns false when setting is false", function()
            local pencil = createMockPencil()
            G_reader_settings:saveSetting("pencil_annotation_enabled", false)
            assert.is_false(pencil:isEnabled())
        end)

    end)

    describe("setEnabled", function()

        it("persists enabled state to G_reader_settings", function()
            local pencil = createMockPencil()
            pencil:setEnabled(false)
            assert.equals(false, G_reader_settings:readSetting("pencil_annotation_enabled"))
        end)

        it("persists re-enabled state to G_reader_settings", function()
            local pencil = createMockPencil()
            pencil:setEnabled(false)
            pencil:setEnabled(true)
            assert.equals(true, G_reader_settings:readSetting("pencil_annotation_enabled"))
        end)

    end)

    describe("onPencilToggleEnabled", function()

        it("disables when currently enabled", function()
            local pencil = createMockPencil()
            pencil:setEnabled(true)
            assert.is_true(pencil:isEnabled())

            pencil:onPencilToggleEnabled()

            assert.is_false(pencil:isEnabled())
            assert.is_true(pencil._teardown_called)
            assert.equals("Pencil disabled", pencil._notification)
        end)

        it("enables when currently disabled", function()
            local pencil = createMockPencil()
            pencil:setEnabled(false)
            assert.is_false(pencil:isEnabled())

            pencil:onPencilToggleEnabled()

            assert.is_true(pencil:isEnabled())
            assert.is_true(pencil._setup_called)
            assert.equals("Pencil enabled", pencil._notification)
        end)

        it("toggles back and forth", function()
            local pencil = createMockPencil()
            pencil:setEnabled(true)
            assert.is_true(pencil:isEnabled())

            pencil:onPencilToggleEnabled()
            assert.is_false(pencil:isEnabled())

            pencil:onPencilToggleEnabled()
            assert.is_true(pencil:isEnabled())
        end)

        it("returns true to indicate event was handled", function()
            local pencil = createMockPencil()
            local result = pencil:onPencilToggleEnabled()
            assert.is_true(result)
        end)

        it("setting persists across mock pencil instances", function()
            local pencil1 = createMockPencil()
            pencil1:setEnabled(true)
            pencil1:onPencilToggleEnabled() -- disable
            assert.is_false(pencil1:isEnabled())

            -- New instance reads same G_reader_settings
            local pencil2 = createMockPencil()
            assert.is_false(pencil2:isEnabled())
        end)

    end)

end)
